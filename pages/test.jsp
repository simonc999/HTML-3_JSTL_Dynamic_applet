<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%--------------------------------------------------------------------------%>
<%-------------------- AUTORIZZAZIONE AREA LAB -----------------------------%>
<%--------------------------------------------------------------------------%>

<c:set var="auth_cod_ruolo" value="4"/>
<c:set var="auth_page" value="home_lab.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Laboratorio"/>

<%@ include file="auth.jspf"%>


<%----------------------------------------------------------------------------------%>
<%--- TOP --%>
<%----------------------------------------------------------------------------------%>

<%@ include file="top.jspf"%>

<td width="60" align="center">
          <!-- COMANDO INDIETRO -->
       <a href="home_lab.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td>
          
<%----------------------------------------------------------------------------------%>
<%--- MIDDLE --%>
<%----------------------------------------------------------------------------------%>
<%@ include file="middle.jspf"%>

<%--QUERY ELENCO TEST--%>

<sql:query var="rset_elenco_test_a">
select t.id_test, tt.tipo, al.prezzo, c.data_pagamento, c.scelto, p.nome_prod, ce.nome, ce.cognome, t.data_ora_esito, t.id_prescrizione, c.data_cand, c.nuova, c.pagamento
    from TEST t, CANDIDATURA c, TIPO_TEST tt,SCHEDA_PROD p, CERT ce, AVERE_LISTINO al
    where t.id_test=c.id_test and tt.id_tipo=t.id_tipo and p.id_scheda=t.id_scheda and al.id_tipo=t.id_tipo and p.user_cert=ce.user_cert and c.user_lab = "${user_userid}" and al.user_lab= "${user_userid}"

<%--WHERE PER LA FUNZIONE FILTRO--%>

<c:if test="${not empty param.test_cercato}">
   AND lower(tt.tipo) LIKE lower(?)
       <sql:param value="${param.test_cercato}%"/>
</c:if> 
<c:if test="${param.stato_scelto =='0' || param.stato_scelto =='2' }">
   AND c.scelto  = ?
       <sql:param value="${param.stato_scelto}"/> 
</c:if>
<c:if test="${param.stato_scelto =='1' && param.stato_scelto !='3'}">
   AND c.scelto  = ? AND t.data_ora_esito is null
       <sql:param value="${param.stato_scelto}"/> 
</c:if>
<c:if test="${param.stato_scelto =='3'}">
   AND t.data_ora_esito is not null AND c.scelto="1"
</c:if>
  order by nome_prod
</sql:query>

<%--QUERY RICAVI LAB--%>

<sql:query var="rset_ricavo">
    select sum(c.pagamento) as ricavo_tot
    from TEST t, CANDIDATURA c,SCHEDA_PROD p
    where t.id_test=c.id_test and t.id_scheda=p.id_scheda and c.user_lab = "${user_userid}" and c.scelto =1 and c.data_pagamento is not null
    group by c.user_lab
 </sql:query>

    <table height="100%" width="100%" border="0">
        <tr>
            <td width="80%" height="100%" valign="top">
                <TABLE align="center" width="80%" height="100%" border="0">
                    <tr height>
                        <td valign="top" height="15%" align="center"><h1 align="center"><font color="#008080">REGISTRO DEI TEST</font></h1>
                        <font color="black" style="font-size:20px;">In questa pagina si trovano tutti i test per cui sono state fatte delle candidature.<br></font>
                            <c:if test="${not empty messaggio3}">
                            <font color="green">${messaggio3}</font>
                            </c:if>
                        </td>
                    </tr>
                    <tr>   
                        <td>
                            <table width="100%" border="0">
                                <tr>
                                    <td width="70%">
                                        <%---------------------------------------------------------------------------------%>
                                        <%-------------FORM CERCA, PER FILTRARE I PRODOTTI INSERENDO IL NOME---------------%>
                                        <%---------------------------------------------------------------------------------%>
                                        <form method="post" action="test.jsp">
                                        <font color="green" size="3"><b> CERCA: </b> </font>
                                        <input type="text" name="test_cercato" value="${param.test_cercato}" 
                                          placeholder="Quale test cerchi?"/>
                                        <input type="image" name="submit" title="CERCA" src="filtra_cerca.png" style="width:15px;height:15px"/>
                                        
                                        <br><br>
                                        
                                        <font color="green" size="3"><b> FILTRA SCEGLIENDO LO STATO DEL TEST:</b> </font>
                                        <br/>
                                        Candidatura rifiutata:  <input type="radio" name="stato_scelto" value="2"   
                                                          onChange="this.form.submit()"
                                                         <c:if test="${param.stato_scelto == '2'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Candidatura effettuata:        <input type="radio" name="stato_scelto" value="0"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '0'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Test in corso:     <input type="radio" name="stato_scelto" value="1"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '1'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Test effettuato: <input type="radio" name="stato_scelto" value="3"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '3'}"> checked </c:if> />   
                                        </form>
                                    </td>
                                    <td valign="bottom" align="left" width="30%">
                                        <form method="post" action="test.jsp">
                                        <input type="submit" value="Ripristina la tua ricerca" style="background:#008080;color:white"/>
                                        </form>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr height="10%">
    
    <%-------------------------------------------------------------------------------------------------------------%>
    <%----------------- TABELLA CONTENENTE I TEST PER CUI SI SONO FATTE LE CANDIDATURE  ---------------------------%>
    <%-------------------------------------------------------------------------------------------------------------%>
                        <td valign="middle">

                                     <%--------INTESTAZIONE TABELLA------------%>                                   

                            <table cellspacing="0" cellpadding="1" border="1" width="1200" >
                                 <tr bgcolor="#008080" height="20%">
                                     <th width="16.5%"><font color="#bfebfc">CODICE TEST</font></th>
                                     <th width="16.5%"><font color="#bfebfc">TIPO</font></th>
                                     <th width="16.5%"><font color="#bfebfc">PRODOTTO</font></th>
                                     <th width="16.5%"><font color="#bfebfc">CERTIFICATORE</font></th>
                                     <th width="16.5%"><font color="#bfebfc">STATO APPROVAZIONE</font></th>
                                     <th width="16.5%"><font color="#bfebfc">COSTO</font></th>
                                 </tr>
                            </table>
                        </td>

                    </tr>
                    <tr height="70%">
                            <td width="100%" height="100%" valign="top">    
                                <div style="width:1250; height:240px; overflow:auto;">
                                <c:choose>
                                 <c:when test="${rset_elenco_test_a.rowCount=='0' && (not empty param.stato_scelto || param.test_cercato)}">
                                        <br>
                                       <p align="left"><font size="4px" color="green"> Non hai ottenuto nessun risultato dalla tua ricerca. Riprova! </font></p>
                                 </c:when>
                             
                                <c:otherwise>
                                     
    
                                                     <%----------CORPO TABELLA----------%>
    
    
                                <table cellspacing="0" cellpadding="1" border="1" width="1200" >
                                        <c:forEach items ="${rset_elenco_test_a.rows}" var= "row"> 
                                            <sql:query var="nuovo_mess">
                                            select m.id_messaggio
                                            from MESSAGGI m, CANDIDATURA c, TEST t
                                            where m.id_test=c.id_test 
                                                  and c.scelto=1 and c.user_lab=m.user_lab and m.nuovo=1 and m.inviato=0 and t.id_test=c.id_test and t.id_test LIKE ?
                                            and m.user_lab LIKE ?
                                            <sql:param value="${row.id_test}"/>
                                            <sql:param value="${user_userid}"/>
                                            </sql:query>
                                            <c:set var="n_nuovi_mess" value="${nuovo_mess.rowCount}"/>
                                            <form method="post" action="scheda_test.jsp">
                                            <tr bgcolor="#eeeeee" height="20">
                                                <td align="center" width ="16.5%">
                                                    <table border="0" width="70%">
                                                        <tr>
                                                            <c:choose>
                                                                <c:when test="${(not empty row.data_pagamento && empty row.data_ora_esito && row.scelto == 1) || (not empty row.data_pagamento && row.scelto == 1 && not empty row.data_ora_esito)}">
                                                                 <td width=75% align="right">
                                                                           <input type="submit" value="${row.id_test}" style="width:70px;background:#a5bacd"/><input type="hidden"  name="id_test" value="${row.id_test}">
                                                                 </td>
                                                                 <td width="25%" align="center">
                                                                     <c:if test="${n_nuovi_mess > 0}">
                                                                     <font color="green" size="1"><b>${n_nuovi_mess}</b></font><img style="width:20px;height:20px;"src="0.png"> 
                                                                     </c:if>
                                                                 </td>                                   
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <td width=60% align="right">
                                                                       <c:out value="${row.id_test}"/>
                                                                    </td>
                                                                    <td width="40%" align="center">
                                                                    </td>
                                                               </c:otherwise>
                                                            </c:choose>
                                                         </tr>
                                                    </table>
                                                </td>
                                                <td width="16.5%"><c:out value="${row.tipo}"/></td>
                                                <td width="16.5%"><c:out value="${row.nome_prod}"/></td>
                                                <td width="16.5%"><c:out value="${row.nome} ${row.cognome}"/></td>
                                                <td align="center" width="16.5%">
<%--------------------------------------------------------------------------%>
<%-------- IF CHE SERVE PER INSERIRE NELLA TABELLA LO STATO CORRETTO -------%>
<%--------------------------------------------------------------------------%>
                                                    <c:if test="${not empty row.data_pagamento && not empty row.data_ora_esito && row.scelto == 1}" >
                                                    <img src="spunta.png" align="center" width="25"/>
                                                    </c:if>
                                                    <c:if test="${not empty row.data_pagamento && empty row.data_ora_esito && row.scelto == 1}">
                                                    <img src="clessidra1.png" align="center" width="25"/>
                                                    </c:if>
                                                    <c:if test="${empty row.data_pagamento && row.scelto == 0 && empty row.data_ora_esito}"> 
                                                    <img src="orologio.png" align="center" width="25"/>
                                                    </c:if>
                                                    <c:if test="${empty row.data_pagamento && row.scelto == 2}"> 
                                                    <img src="xrossa.png" align="center" width="25"/>
                                                    </c:if>
                                                </td>
                                                <td align="center" width="16.5%">
                                                  <c:if test="${not empty row.data_pagamento}" >                           
                                                  ${row.pagamento} &euro;
                                                  </c:if>
                                                  <c:if test="${empty row.data_pagamento}" >
                                                   ---
                                                  </c:if>
                                                </td>
                                            </tr>
                                            </form>
                                         </c:forEach> 
                                       </table>  
                                    
                                 </c:otherwise>
                            </c:choose>
                        </div>
                                </td>
                    </tr>
                        <c:choose>
                            <c:when test="${not empty rset_ricavo.rows[0].ricavo_tot}">
                             <tr height="10%" > 
                               <td height="5%" align="center" bgcolor="#eeeeee"><p style="font-size:20px;">Il laboratorio fino a questo momento ha guadagnato:<font color="#008080">${rset_ricavo.rows[0].ricavo_tot} &euro; </font></p>
                               </td>
                             </tr>
                            </c:when>
                            <c:otherwise>
                             <tr height="10%"> 
                               <td align="center" bgcolor="#eeeeee"><p style="font-size:20px;">Il laboratorio non ha ancora ottenuto ricavi.</p></td>
                             </tr>
                            </c:otherwise>
                        </c:choose>
                </TABLE>
            </td>
            <td width="20%" height="100%" >
                
                    <%-----------------%>
                    <%---LEGENDA-------%>
                    <%-----------------%>
                        
                <table align="center" border="2" bordercolor="" bgcolor="white" cellspacing="0" cellpadding="1">
                <h3 align="center"><font color="green">LEGENDA</font></h3>
                    <tr><td><font color="black">Test effettuato </font> </td>
                        <td><img src="spunta.png" width="25"/></td>
                    </tr>
                    <tr><td><font color="black">Test in svolgimento</font></td>
                        <td><img src="clessidra1.png" width="25"/></td>
                    </tr>
                    <tr>
                        <td><font color="black">Candidatura effettuata (in attesa)</font></td>
                        <td><img src="orologio.png" width="25"/></td>
                    </tr>
                    <tr>
                        <td><font color="black">Candidatura rifiutata</font></td>
                        <td><img src="xrossa.png" width="25"/></td>
                    </tr>
                </table>
                        
            </td>
        </tr>
    </table>          
<%@ include file="bottom.jspf"%>

 

 