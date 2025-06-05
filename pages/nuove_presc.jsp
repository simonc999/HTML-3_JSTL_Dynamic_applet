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


 
<td width="60" align="center">
          <!-- COMANDO BACK -->

              <a href="home_lab.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>

         
       </td>
  <%--------------------------------------------------------------------------------------%>
<%------------------------------QUERY PER ESTRARRE VALORI DELLE PRESCRIZIONI---------------------------------%>
<%--------------------------------------------------------------------------------------%>

<%@ include file="middle.jspf"%>
<sql:query var="rset_nuove_presc">
   select t.id_prescrizione, p.Nome_prod, t.id_test, tt.tipo, c.nome, p.id_scheda, p.uso, p.Nome_prod, p.tipo, p.beneficio, c.nome,p.materiali, vp.nuova, tt.descrizione 
   from TEST t, SCHEDA_PROD p, TIPO_TEST tt, CPR c, VISUALIZZARE_PRESC vp
   where t.id_scheda= p.id_scheda and tt.id_tipo=t.id_tipo and c.user_cpr=p.user_cpr and p.stato=2 and t.id_test not in(select id_test from CANDIDATURA where user_lab="${user_userid}" or data_pagamento is not null or 
    scelto = '1') and tt.id_tipo in (select id_tipo from AVERE_LISTINO where user_lab="${user_userid}") and vp.user_lab="${user_userid}" and vp.id_presc=t.id_prescrizione
</sql:query>



<sql:query var="prod">
   select p.uso, p.Nome_prod, p.tipo, p.beneficio, c.nome,p.materiali, p.foto1, p.foto2, p.foto3
   from SCHEDA_PROD p, CPR c
   where c.user_cpr=p.user_cpr and p.id_scheda="${param.id_scheda}"
</sql:query>



<table width="100%" height="100%" border="0">
    <tr>
<%--------------------------------------------------------------------------------------%>
<%-----------------------------------TABELLA PRICIPALE----------------------------------%>
<%--------------------------------------------------------------------------------------%>
        <td width="75%" height="100%" >
        <TABLE width="82%" height="90%" border="0" align="right">

<%--------------------------------------------------------------------------------------%>
<%-----------------CHOOSE MESSAGGIO SE NON CI SONO PRESCRIZIONI-------------------------%>
<%--------------------------------------------------------------------------------------%>
             <c:choose>
                 <c:when test="${empty rset_nuove_presc.rows[0].id_prescrizione}">
                  <tr height="20%">
                   <td  valign="middle"><h1 align="center"><font color="#007171">NUOVE PRESCRIZIONI</font></h1><p align="center" valign="middle"><font size= "4px" font color="black">Di seguito sono riportate le prescrizioni ancora disponibili per la candidatura</font></p></td>
                  </tr>
                  <tr valign="middle">
                   <td valign="middle" align="center" width="100%"><p><font style="font-weight:bold; font-size:18px;" color="green">Al momento non ci sono prescrizioni disponibili per la candidatura.</font></p></td>
                  </tr>
                 </c:when>
                 <c:otherwise>
                  <tr height="20%">
                         <td ><h1 align="center"><font color="#007171">&nbsp&nbspNUOVE PRESCRIZIONI</font></h1><p align="center" valign="middle"><font size= "3px" font color="black">&nbsp&nbspDi seguito sono riportate le prescrizioni ancora disponibili per la candidatura</font><br></p></td>
                  </tr>
                    <tr>
                            <td><br>
                               <table cellspacing="0" cellpadding="1"  width="950" border="0" >
                                <tr bgcolor="#008080">
                                    <td >
                                        <table width="100%" cellspacing="0" cellpadding="1" border="1">
                                            <tr>
                                                <th width="25%"><font color="#bfebfc">PRESCRIZIONE</font></th>
                                                <th width="25%"><font color="#bfebfc">PRODOTTO</font></th>
                                                <th width="25%"><font color="#bfebfc">CASA PRODUTTRICE</font></th>
                                                <th width="25%"><font color="#bfebfc">TEST RICHIESTO</font></th>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <font color="green">Per candidarsi ad un test selezionare la rispettiva prescrizione.</font>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                               </tr>
                               </table>
                      
                            </td>
                     </tr>
                    <tr>
                       <td>
<%--------------------------------------------------------------------------------------%>
<%-----------------------RIEMPIMENTO TABELLA CON VALORI PRESI DA QUERY------------------%>
<%--------------------------------------------------------------------------------------%>
                          <div style="width:1000px; height:300px; overflow:auto;">
                            <table cellspacing="0" cellpadding="1" border="1" width="950" bgcolor="white">
                              <c:forEach items="${rset_nuove_presc.rows}" var = "row" > 

                            <form method="post" action="scheda_presc.jsp">
                            <tr  height="20"
<%--------------------------------------------------------------------------------%>
<%--C:IF CHE PERMETTE DI VEDERE LA RIGA EVIDENZIATA DI AZZURO PER LE NUOVE PRESCRIZIONI--%>
<%--------------------------------------------------------------------------------%>
        <c:if test="${row.nuova == 'true'}"> 
         bgcolor="#ADD8E6" </c:if>>

                               <td align="center" width="20%">
                               <input type="hidden" name="scheda_presc" value="123"/>
                               <input type="submit" name="tasto" value="${row.id_prescrizione}" style="width:100px;background:#a5bacd"/>
                               <input type="hidden" name="id_prescrizione" value="${row.id_prescrizione}"/> 
                            </form>
                               </td>
                            <form method="post" action="#" >
                                <td width="20%" align="center"><input type="submit" value="${row.Nome_prod}" name="visualizza" style="width:150px;background:#a5bacd"/></td>
                                <td width="20%"><c:out value="${row.nome}"/></td>
                                <td width="20%"><c:out value="${row.descrizione}"/></td>
                                <input type="hidden" name="id_scheda" value="${row.id_scheda}"/> 
                               </tr>
                             </form>
                             </c:forEach>
                             </table>  
                          </div>
                       </td>
                     </tr>
              </c:otherwise>
             </c:choose>
        </TABLE>
        </td>
        <td width="25%" height="100%" >
<%--------------------------------------------------------------------------------------%>
<%----------------------------------VISUALIZZA SCHEDA PROD------------------------------%>
<%--------------------------------------------------------------------------------------%>
<c:if test="${not empty param.visualizza}">
<table width="200">
<tr>


 <form method="post" action"#">
                <td valign="bottom" align="right" width="200">
                  <br> 
                  <input type="image" name="submit" style="width:20px;height:20px" src="rosso1.png"/>
                  <input type="hidden" name="id_test" value="${info_test.rows[0].id_test}"/>
                  <input type="hidden" name="id_scheda" value="${param.id_scheda}"/>
                  <input type="hidden" name="id_scheda" value="${user_userid}"/>
                </td>
            </form>
            </tr>
<tr>
             <table width="200"  border="1" cellpadding="8" cellspacing="0"  bordercolor="#008080" bgcolor="#a5bacd" align="left">
                <tr style="margin-right:8px;">
                    <td align="right" bgcolor="#a5bacd" height="10%" >
                        <font size="4"> SCHEDA PRODOTTO:<br/> ${param.id_scheda}</font> <br/>
                    
                 <c:if test="${not empty prod.rows[0].foto1}">
                <IMG border="0" title="clicca per visualizzare le immagini" src="${prod.rows[0].foto1}" width="30" height="30"/>
                 </c:if>
                 <c:if test="${not empty prod.rows[0].foto2}">
                <IMG border="0" title="clicca per visualizzare le immagini" src="${prod.rows[0].foto2}" width="30" height="30"/>
                </c:if>
                  <c:if test="${not empty prod.rows[0].foto3}">
                <IMG border="0" title="clicca per visualizzare le immagini" src="${prod.rows[0].foto3}" width="30" height="30"/>
                 </c:if>
                    </td>
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="15%" style="padding-right:10px"> 
                    Nome:  &nbsp${prod.rows[0].Nome_prod} 
                    </td> 
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="15%" style="padding-right:10px"> 
                    CPR:  &nbsp${prod.rows[0].nome} 
                    </td> 
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="10%" style="padding-right:10px"> 
                    Tipo:  &nbsp${prod.rows[0].tipo} 
                    </td> 
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px"> 
                    Uso:  &nbsp${prod.rows[0].uso} 
                    </td> 
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px"> 
                    Materiali: &nbsp ${prod.rows[0].materiali} 
                    </td> 
                </tr>
                <tr>
                    <td align="left" bgcolor="#a5bacd" height="20%" style="padding-right:10px"> 
                    Beneficio:  &nbsp${prod.rows[0].beneficio} 
                    </td> 
                </tr>
             </table>
</tr>
</table>
            </c:if>
        </td>
    </tr>
</table>
<%@ include file="bottom.jspf"%>

 