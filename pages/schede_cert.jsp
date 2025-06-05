<%@ page session="true" 
language="java" 
contentType="text/html; charset=UTF-8" 
import="java.sql.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://it.unipv.bmilab.uploadtags"      prefix="upload" %>

<%----- FRAMMENTO AUTH ------%>
<c:set var="auth_cod_ruolo" value="3"/>
<c:set var="auth_page" value="home_cert.jsp"/>
<c:set var="auth_messaggio" value="L'accesso a questa pagina e' riservato a chi svolge il ruolo di Certificatore"/>

<%@ include file="auth.jspf"%>


<%@ include file="top.jspf"%>
        <!-- COMANDO INDIETRO -->
<td width="60">
       <a href="home_cert.jsp"> 
            <img style="width:60px;height:60px" src="indietro.png">
       </a>
     </td> 

<%@ include file="middle.jspf"%>

<%------------------------------------------------------------------------------------------%>
<%-----------------------SE IL PERCORSO DI CERT. DI UN PRODOTTO TERMINA(stato rosso=3)
 -----------------------------------ALLORA CERT-----------------------------------------------
 ------------------------ NON AVRA' PIU' VISIONE DEL PRODOTTO---------------------------------%>
<%-------------------------------------------------------------------------------------------%>
<sql:query var="rset_elencoprod">
    select p.nome_prod, p.id_scheda, p.user_cert, c.nome, p.nuovo_assegnato, p.tipo
    from SCHEDA_PROD p, CPR c
    where  fine_prat is null
           and p.user_cpr = c.user_cpr
           and p.user_cert=? 

<sql:param value="${user_userid}"/>
    
  <c:if test="${not empty param.prod_cercato}">
     AND lower(nome_prod) LIKE lower(?)
     <sql:param value="${param.prod_cercato}%"/>
</c:if>
     <%--WHERE PER LA FUNZIONE FILTRO--%> 
<c:if test="${param.stato_scelto =='0'}">
   AND p.tipo  = "Beauty"
</c:if>
<c:if test="${param.stato_scelto =='1'}">
   AND p.tipo  ="Igiene"
</c:if>
<c:if test="${param.stato_scelto =='2'}">
   AND p.tipo  ="Cura e benessere"
</c:if>
<c:if test="${param.stato_scelto =='3'}">
   AND p.tipo  = "Alimentare"
</c:if>
<c:if test="${param.stato_scelto =='4'}">
   AND p.tipo  = "Dispositivi medici"
   </c:if>
<c:if test="${param.stato_scelto =='5'}">
   AND p.tipo  = "Farmaceutico"
</c:if> 

  order by nome_prod
  
</sql:query>

<c:set var="n_schede" value="${rset_elencoprod.rowCount}"/>

<%--------------------------------------------------------------------%>
<%----------QUERY CHE ESTRAE NOME E COGNOME DEL CERTIFICATORE---------%>
<%--------------------------------------------------------------------%>

<sql:query var="Nome_cert">
    select nome, cognome
    from CERT
    where user_cert="${user_userid}"
</sql:query>

<TABLE align="top" border="0" height="95%">
    <tr height="20%">
                                          
    
                            
    
<%------TABELLA PRODOTTI-----------------------%>                            
<td align="left" ><h3 align="center"><font color="#008080" style="font-size:30px;">LISTA PRODOTTI ASSEGNATI DALL'AGENZIA GOVERNATIVA</font></h3> </td>


<br/><font color="green" size="4"> ${messaggio} </font>
<br/>
<tr>
<td> 
<table width="100%" border="0">
                                <tr>
                                    <td width="70%">
<%---------------------------------------------------------------------------------%>
<%----FORM CERCA, PER FILTRARE I PRODOTTI -----%>
<%---------------------------------------------------------------------------------%>
<form method="post" action="schede_cert.jsp">
<font color="green" size="3"><b> CERCA: </b> </font>
<input type="text" name="prod_cercato" value="${param.prod_cercato}" placeholder="Quale prodotto cerchi?"/>
<input type="image" name="submit" title="CERCA" src="filtra_cerca.png" style="width:15px;height:15px"/>
<br/><br/>
<font color="green" size="3"><b> FILTRA SCEGLIENDO LA TIPOLOGIA DI PRODOTTI:</b> </font>
                                        <br/>
                                        Beauty:  <input type="radio" name="stato_scelto" value="0"   
                                                          onChange="this.form.submit()"
                                                         <c:if test="${param.stato_scelto == '0'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Igiene:        <input type="radio" name="stato_scelto" value="1"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '1'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Cura e benessere:     <input type="radio" name="stato_scelto" value="2"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '2'}"> checked </c:if> />
                                        &nbsp&nbsp&nbsp
                                        Alimentare: <input type="radio" name="stato_scelto" value="3"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '3'}"> checked </c:if> />  
                                        &nbsp&nbsp&nbsp
                                        Dispositivi medici: <input type="radio" name="stato_scelto" value="4"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '4'}"> checked </c:if> /> 
                                        &nbsp&nbsp&nbsp
                                        farmaceutico: <input type="radio" name="stato_scelto" value="5"
                                                          onChange="this.form.submit()"
                                                          <c:if test="${param.stato_scelto == '5'}"> checked </c:if> />


                                    </form>
                                    </td>
                                    <td valign="bottom" align="left" width="30%">
                                        <form method="post" action="schede_cert.jsp">
                                        <input type="submit" value="Ripristina la tua ricerca" style="background:#008080;color:white;"/>
                                        </form>
                                    </td>
                                </tr>
                            </table>

<%---------------------------------------------------------------------------------%>
<%-- MESSAGGIO CHE APPARE QUANDO NON CI SONO PRODOTTI CHE VENGONO TROVATI DAL CERCA
     --%>
<%---------------------------------------------------------------------------------%>


<tr height="10%">
<td>

  <table cellspacing="0" cellpadding="1" border="1" width="1100px"   >
    <tr bgcolor="#008080">
     <th width="13.5%"><font color="#bfebfc">Prodotto         </font></th>
     <th width="13.5%"><font color="#bfebfc">Scheda prodotto  </font></th>
     <th width="13.5%"><font color="#bfebfc">Casa produttrice </font></th>
     <th width="13.5%"><font color="#bfebfc">Test effettuati  </font></th>
     <th width="13.5%"><font color="#bfebfc">Test prescritti  </font></th>
     <th width="13.5%"><font color="#bfebfc">Stato avanzamento</font></th>
    </tr>
   </table>
   <br>
    </td>
    </tr>
    <tr height="50%">

<c:choose>
    <c:when test="${(not empty param.prod_cercato || not empty param.stato_scelto) && n_schede == 0}">
     <td height="100%" width="100%" align="left" valign="top">
<br>
<p><font color="green"> Non hai ottenuto nessun risultato dalla tua ricerca. Riprova! </font></p>
</td>
    </c:when>
    <c:otherwise>
      <td align="left" >
    <div style="width:1150px; height:200px; overflow:auto;">
    <table cellspacing="0" cellpadding="1" border="1" width="1100px" bgcolor="#eeeeee" >
    <c:forEach items="${rset_elencoprod.rows}" var="row">
    <form method="post" action="scheda_prod.jsp" bgcolor="#008080">


<sql:query var="test_presc">
    select t.id_prescrizione
    from TEST t
    where  t.user_cert="${user_userid}"
           and t.id_scheda = ?        
<sql:param value="${row.Id_scheda}"/>
</sql:query>

<sql:query var="test_eff">
    select t.id_prescrizione
    from TEST t
    where  t.data_ora_esito is not null and t.user_cert="${user_userid}"
           and t.id_scheda = ?        
<sql:param value="${row.Id_scheda}"/>
</sql:query>



<c:set var="n_presc" value="${test_presc.rowCount}"/>
<c:set var="n_eff" value="${test_eff.rowCount}"/>

<c:choose>
 <c:when test="${n_presc>0}">
<c:set var="percentuale" value="${(n_eff/n_presc)*100}"/>
 </c:when>
 <c:otherwise>
  <c:set var="percentuale" value="0"/>
</c:otherwise>
</c:choose>
                                                                
     <tr  height="20" <c:if test="${row.nuovo_assegnato == 'true'}">
      bgcolor="#ADD8E6" </c:if> >
      <td align="center" width="13.5%"> <input type="submit" value="${row.Nome_prod}" style="width:150px;background:#a5bacd"/>  </td>   
      <td align="center" width="13.5%">          <c:out value="${row.Id_scheda}"/>                      </td>
      <td align="center" width="13.5%"><c:out value="${row.nome}"/></td>
      <td align="center" width="13.5%">${n_eff}</td>
      <td align="center" width="13.5%">${n_presc}</td>
      <td align="center" width="13.5%">${percentuale}%</td>

                                           
     <input type="hidden"  name="id_scheda" value="${row.Id_Scheda}">
     <input type="hidden"  name="Nome_prod" value="${row.Nome_prod}">
     <input type="hidden"  name="Nome_prod" value="${user.userid}">

                                                                </tr>
                                                                </form>
                                                         </c:forEach>
                                                    </table>  
                                                </div>    
                                    <br>
                                   </td>
                       </c:otherwise>
                       </c:choose>
                      </tr>
        </TABLE>
<%@ include file="bottom.jspf"%>

 